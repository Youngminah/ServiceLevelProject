//
//  HobbySetViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import RxKeyboard
import SnapKit

final class HomeSearchViewController: UIViewController {

    let searchSesacButton = DefaultButton(title: "새싹 찾기")
    private let searchBar = UISearchBar()
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: CollectionViewLeftAlignFlowLayout())

    private lazy var input = HomeSearchViewModel.Input(
        viewWillAppearSignal: self.rx.viewWillAppear.asSignal(),
        searhBarTapWithText: searchBar.rx.searhBarTapWithText,
        itemSelectedSignal: collectionView.rx.modelSelected(HobbyItem.self).asSignal(),
        sesacSearchButtonTap: searchSesacButton.rx.tap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: HomeSearchViewModel
    private let disposeBag = DisposeBag()

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<HobbySectionModel> (configureCell: { dataSource, collectionView ,indexPath ,item in

        switch item {
        case .near(let item):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NearHobbyCell.identifier, for: indexPath) as! NearHobbyCell
            cell.updateUI(item: item)
            return cell

        case .selected(let item):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedHobbyCell.identifier, for: indexPath) as! SelectedHobbyCell
            cell.updateUI(item: item)
            return cell
        }
    }) { dataSource, collectionView, kind, indexPath in
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: HobbySectionView.identifier,
            for: indexPath
        ) as! HobbySectionView
        headerView.setTitle(text: HobbySection(index: indexPath.section).headerTitle)
        return headerView
    }

    init(viewModel: HomeSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("HomeSearchViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        bindKeyboard()
        bind()
        setConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }

    private func bind() {
        output.hobbyItems
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.showToastAction
            .emit(onNext: { [weak self] text in
                self?.view.makeToast(text, position: .top)
            })
            .disposed(by: disposeBag)

        output.removeSearchBarTextAction
            .emit(onNext: { [weak self] in
                self?.searchBar.text = nil
            })
            .disposed(by: disposeBag)

        output.indicatorAction
            .drive(onNext: {
                $0 ? IndicatorView.shared.show(backgoundColor: Asset.transparent.color) : IndicatorView.shared.hide()
            })
            .disposed(by: disposeBag)
    }

    private func setViews() {
        view.addSubview(collectionView)
        view.addSubview(searchSesacButton)
    }

    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.equalToSuperview()
        }
        searchSesacButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        registerCollectionView()
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchSesacButton.isValid = true
    }

    private func registerCollectionView() {
        collectionView.register(NearHobbyCell.self,
                                forCellWithReuseIdentifier: NearHobbyCell.identifier)
        collectionView.register(SelectedHobbyCell.self,
                                forCellWithReuseIdentifier: SelectedHobbyCell.identifier)
        collectionView.register(HobbySectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HobbySectionView.identifier)
    }
}

// MARK: - keyboard
extension HomeSearchViewController {

    private func bindKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(rx.keyboardHeightChanged)
            .disposed(by: disposeBag)

        view.rx
            .tapGesture()
            .when(.recognized)
            .do { [weak self] recognize in
                guard let self = self else { return }
                if !self.searchBar.isFirstResponder {
                    recognize.cancelsTouchesInView = false
                }
            }
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }

    func raiseKeyboardWithButton(keyboardChangedHeight: CGFloat, button: DefaultButton) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var bottomOffset = self.view.safeAreaInsets.bottom - keyboardChangedHeight
            var (offset, radius): (Int, CGFloat) = (0, 0)
            if keyboardChangedHeight == 0 {
                (offset, radius) = (16, 8)
                bottomOffset = -16
            }
            button.snp.updateConstraints { make in
                make.right.equalToSuperview().offset(-offset)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(bottomOffset)
                make.left.equalToSuperview().offset(offset)
            }
            button.layer.cornerRadius = radius
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
