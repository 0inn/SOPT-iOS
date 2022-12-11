//
//  ListDetailVC.swift
//  Presentation
//
//  Created by 양수빈 on 2022/11/28.
//  Copyright © 2022 SOPT-Stamp-iOS. All rights reserved.
//

import UIKit

import Combine
import PhotosUI
import SnapKit
import Then

import Core
import Domain
import DSKit

import Lottie

public enum TextViewState {
    case inactive // 비활성화(키보드X, placeholder)
    case active // 활성화(키보드O, 텍스트 입력 상태)
    case completed // 작성 완료
}

extension StarViewLevel {
    var buttonTitleColor: UIColor {
        switch self {
        case .levelOne, .levelTwo:
            return DSKitAsset.Colors.white.color
        case .levelThree:
            return DSKitAsset.Colors.gray700.color
        }
    }
    
    var pointColor: UIColor {
        switch self {
        case .levelOne:
            return DSKitAsset.Colors.pink300.color
        case .levelTwo:
            return DSKitAsset.Colors.purple300.color
        case .levelThree:
            return DSKitAsset.Colors.mint300.color
        }
    }
    
    var disableColor: UIColor {
        switch self {
        case .levelOne:
            return DSKitAsset.Colors.pink200.color
        case .levelTwo:
            return DSKitAsset.Colors.purple200.color
        case .levelThree:
            return DSKitAsset.Colors.mint200.color
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .levelOne:
            return DSKitAsset.Colors.pink100.color
        case .levelTwo:
            return DSKitAsset.Colors.purple100.color
        case .levelThree:
            return DSKitAsset.Colors.mint100.color
        }
    }
}

public class ListDetailVC: UIViewController {
    
    // MARK: - Properties
    
    public var viewModel: ListDetailViewModel!
    public var factory: ModuleFactoryInterface!
    private var cancelBag = CancelBag()
    private var sceneType: ListDetailSceneType {
        get {
            return self.viewModel.listDetailType
        } set(type) {
            self.viewModel.listDetailType = type
        }
    }
    private var starLevel: StarViewLevel {
        return self.viewModel.starLevel
    }
    private var originImage: UIImage = UIImage()
    private var originText: String = ""
    private let deleteButtonTapped = PassthroughSubject<Bool, Never>()
    
    // MARK: - UI Components
    
    private lazy var naviBar = CustomNavigationBar(self, type: .titleWithLeftButton)
        .setTitle(I18N.ListDetail.mission)
        .setRightButton(.none)
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentStackView = UIStackView()
    private lazy var missionView = MissionView(level: starLevel, mission: "미션주세요미션미션미션미션")
    private let missionImageView = UIImageView()
    private let imagePlaceholderLabel = UILabel()
    private let textView = UITextView()
    private let dateLabel = UILabel()
    private lazy var bottomButton = CustomButton(title: sceneType == .none ? I18N.ListDetail.missionComplete : I18N.ListDetail.editComplte)
        .setEnabled(false)
        .setColor(bgColor: starLevel.pointColor,
                     disableColor: starLevel.disableColor,
                     starLevel.buttonTitleColor)
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModels()
        self.setLayout()
        self.setStackView()
        self.setDefaultUI()
        self.setUI(sceneType)
        self.setObserver()
        self.setGesture()
        self.setDelegate()
    }
}

// MARK: - Methods

extension ListDetailVC {
    private func bindViewModels() {
        let rightButtonTapped = naviBar.rightButtonTapped
            .map { self.sceneType }
            .asDriver()
        
        let bottomButtonTapped = bottomButton
            .publisher(for: .touchUpInside)
            .map { _ in
                ListDetailRequestModel(imgURL: self.missionImageView.image ?? UIImage(), content: self.textView.text)
            }
            .asDriver()
        
        let input = ListDetailViewModel.Input(bottomButtonTapped: bottomButtonTapped,
                                              rightButtonTapped: rightButtonTapped,
                                              deleteButtonTapped: deleteButtonTapped.asDriver())
        let output = self.viewModel.transform(from: input, cancelBag: self.cancelBag)
        
        output.postSuccessed
            .sink { successed in
                self.presentCompletedVC(level: self.starLevel)
            }.store(in: self.cancelBag)
        
        output.showDeleteAlert
            .sink { delete in
                if delete {
                    self.presentDeleteAlertVC()
                } else {
                    self.tappedEditButton()
                }
            }.store(in: self.cancelBag)
        output.deleteSuccessed
            .sink { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.makeAlert(title: I18N.Default.error, message: I18N.Default.networkError)
                }
            }.store(in: self.cancelBag)
    }
    
    private func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(requestPhotoLibrary))
        missionImageView.addGestureRecognizer(tapGesture)
    }
    
    private func tappedEditButton() {
        self.sceneType = .edit
        self.setUI(sceneType)
    }
    
    private func setDelegate() {
        self.textView.delegate = self
    }
    
    private func openLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .livePhotos])
        
        let pickerVC = PHPickerViewController(configuration: configuration)
        pickerVC.delegate = self
        
        self.present(pickerVC, animated: true)
    }
    
    private func moveToSetting() {
        let alertController = UIAlertController(title: "앨범 접근 권한 거부", message: "앨범 접근이 거부되었습니다. 앱의 일부 기능을 사용할 수 없습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "권한 설정으로 이동하기", style: .default) { action in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL)
            }
        }
        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        makeVibrate()
        
        self.present(alertController, animated: true)
    }
    
    private func presentDeleteAlertVC() {
        let alertVC = self.factory.makeAlertVC(title: I18N.ListDetail.deleteTitle, customButtonTitle: I18N.Default.delete)
        alertVC.customAction = {
            self.deleteButtonTapped.send(true)
        }
        
        self.present(alertVC, animated: true)
    }
    
    private func presentCompletedVC(level: StarViewLevel) {
        let missionCompletedVC = MissionCompletedVC()
            .setLevel(level)
        missionCompletedVC.completionHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        missionCompletedVC.modalPresentationStyle = .overFullScreen
        missionCompletedVC.modalTransitionStyle = .crossDissolve
        self.present(missionCompletedVC, animated: true)
    }
    
    // MARK: - @objc
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let scrollPosition = CGPoint(x: 0, y: keyboardSize.height + (UIDevice.current.hasNotch ? -40 : 66))
            self.scrollView.setContentOffset(scrollPosition, animated: true)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc
    private func requestPhotoLibrary() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            openLibrary()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                switch newStatus {
                case .authorized, .limited :
                    self.openLibrary()
                case .denied:
                    DispatchQueue.main.async {
                        self.moveToSetting()
                    }
                default:
                    break
                }
            }
        case .denied:
            DispatchQueue.main.async {
                self.moveToSetting()
            }
        default:
            print("권한 설정이 이상하게 되었어요")
        }
    }
}

// MARK: - PHPickerViewControllerDelegate

extension ListDetailVC: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        self.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return }
                    self.missionImageView.image = selectedImage
                    self.imagePlaceholderLabel.isHidden = true
                    if self.textView.hasText && self.textView.text != I18N.ListDetail.memoPlaceHolder { self.bottomButton.setEnabled(true) }
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ListDetailVC: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == I18N.ListDetail.memoPlaceHolder {
            self.textView.text = .none
            setTextView(.active)
        }
        return true
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text == "" {
            self.textView.text = I18N.ListDetail.memoPlaceHolder
            setTextView(.inactive)
        }
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let missionImageViewFilled = missionImageView.image != nil
        self.bottomButton.setEnabled(textView.hasText && missionImageViewFilled)
    }
}

// MARK: - UI & Layout

extension ListDetailVC {
    private func setUI(_ type: ListDetailSceneType) {
        if type == .edit {
            self.naviBar
                .setRightButton(.delete)
                .resetLeftButtonAction {
                    self.sceneType = .completed
                    self.setUI(self.sceneType)
                }
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            originText = textView.text
            originImage = missionImageView.image ?? UIImage()
        } else {
            if textView.text != I18N.ListDetail.memoPlaceHolder && textView.text != originText {
                textView.text = originText
            }
            
            if let image = missionImageView.image,
               image != originImage {
                missionImageView.image = originImage
            }
            self.naviBar.resetLeftButtonAction()
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
        
        switch type {
        case .none, .edit:
            self.scrollView.isScrollEnabled = true
            self.missionView.backgroundColor = DSKitAsset.Colors.gray50.color
            self.setTextView(.inactive)
            self.imagePlaceholderLabel.isHidden = missionImageView.image == nil ? false : true
            self.missionImageView.isUserInteractionEnabled = true
            self.bottomButton.isHidden = false
            self.dateLabel.isHidden = true
        case .completed:
            self.scrollView.isScrollEnabled = false
            self.scrollView.setContentOffset(.zero, animated: true)
            self.naviBar.setRightButton(.addRecord)
            self.missionView.backgroundColor = starLevel.bgColor
            self.setTextView(.completed)
            self.imagePlaceholderLabel.isHidden = true
            self.bottomButton.isHidden = true
            self.dateLabel.isHidden = false
            self.missionImageView.image = DSKitAsset.Assets.splashImg2.image
            self.missionImageView.isUserInteractionEnabled = false
        }
    }
    
    private func setDefaultUI() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        self.view.backgroundColor = .white
        self.setStatusBarBackgroundColor(.white)
        
        self.scrollView.keyboardDismissMode = .onDrag
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.contentInset = UIEdgeInsets(top: 7, left: 0, bottom: 32, right: 0)
        
        self.missionImageView.backgroundColor = DSKitAsset.Colors.gray50.color
        self.missionImageView.layer.masksToBounds = true
        self.missionImageView.contentMode = .scaleAspectFill
        self.missionImageView.layer.cornerRadius = 9
        
        self.textView.layer.cornerRadius = 12
        self.textView.layer.borderColor = starLevel.pointColor.cgColor
        self.textView.textContainerInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        self.imagePlaceholderLabel.textColor = DSKitAsset.Colors.gray500.color
        self.dateLabel.textColor = DSKitAsset.Colors.gray600.color
        
        self.imagePlaceholderLabel.setTypoStyle(.subtitle2)
        self.textView.setTypoStyle(.caption1)
        self.dateLabel.setTypoStyle(.number3)
        
        self.imagePlaceholderLabel.text = I18N.ListDetail.imagePlaceHolder
        self.textView.text = I18N.ListDetail.memoPlaceHolder
        self.dateLabel.text = "2022.10.25"
        
        self.textView.returnKeyType = .done
    }
    
    private func setTextView(_ state: TextViewState) {
        switch state {
        case .inactive:
            self.textView.backgroundColor = DSKitAsset.Colors.gray50.color
            self.textView.textColor = DSKitAsset.Colors.gray600.color
            self.textView.layer.borderWidth = .zero
            self.textView.isEditable = true
        case .active:
            self.textView.backgroundColor = DSKitAsset.Colors.white.color
            self.textView.textColor = DSKitAsset.Colors.gray900.color
            self.textView.layer.borderWidth = 1
            self.textView.isEditable = true
        case .completed:
            self.textView.backgroundColor = DSKitAsset.Colors.gray50.color
            self.textView.textColor = DSKitAsset.Colors.gray900.color
            self.textView.layer.borderWidth = .zero
            self.textView.isEditable = false
        }
    }
    
    private func setStackView() {
        self.contentStackView.axis = .vertical
        self.contentStackView.distribution = .fill
        self.contentStackView.spacing = UIDevice.current.hasNotch ? 16 : 14
    }
    
    private func setLayout() {
        self.setScrollViewLayout()
        self.view.addSubviews(scrollView, naviBar)
        
        naviBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(naviBar.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setStackViewLayout() {
        contentStackView.addArrangedSubviews(missionView, missionImageView, textView)
        
        missionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        missionImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.missionImageView.snp.width)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.contentStackView.snp.width).multipliedBy(0.39)
        }
        
        contentStackView.addSubview(imagePlaceholderLabel)
        
        imagePlaceholderLabel.snp.makeConstraints { make in
            make.center.equalTo(missionImageView.snp.center)
        }
    }
    
    private func setScrollViewLayout() {
        self.setStackViewLayout()
        
        self.scrollView.addSubviews(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.contentView.addSubviews(contentStackView, dateLabel, bottomButton)
        
        contentStackView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(22)
            make.top.equalTo(contentStackView.snp.bottom).offset(12)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(contentStackView.snp.bottom).offset(UIDevice.current.hasNotch ? 30 : 20)
            make.height.equalTo(56)
        }
    }
}
