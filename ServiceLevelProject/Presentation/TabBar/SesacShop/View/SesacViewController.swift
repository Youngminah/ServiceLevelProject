//
//  SesacViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import UIKit
import RxCocoa
import RxSwift

final class SesacViewController: UIViewController {

    weak var delegate: PreviewSesacDeleagete?
    var sesacCollectionList = [Int]()

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    //private let sesacLists = BehaviorRelay<[SesacImageCase]>(value: SesacImageCase.allCases)

    private lazy var input = SesacViewModel.Input(
        viewDidLoad: Observable.just(()),
        priceButtonTap: priceButtonTap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: SesacViewModel
    private let disposeBag = DisposeBag()

    private let priceButtonTap = PublishRelay<Int>()

    init(viewModel: SesacViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("SesacShopViewController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        bind()
        setConstraints()
    }

    private func bind() {
        output.sesacLists
            .drive(collectionView.rx.items(cellIdentifier: SesacCell.identifier, cellType: SesacCell.self)) { [weak self] index, sesac, cell in
                guard let self = self else { return }
                cell.updateUI(sesac: sesac, isHaving: self.sesacCollectionList[index])
                cell.priceButton.rx.tap.asSignal()
                    .map { index }
                    .emit(to: self.priceButtonTap)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(SesacImageCase.self)
            .asSignal()
            .emit(onNext: { [weak self] item in
                self?.delegate?.updateSesac(sesac: item)
            })
            .disposed(by: disposeBag)
    }

    private func setViews() {
        view.addSubview(collectionView)
    }

    private func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
        }
    }

    private func setConfigurations() {
        collectionView.register(SesacCell.self,
                                forCellWithReuseIdentifier: SesacCell.identifier)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.showsVerticalScrollIndicator = false
    }
}

extension SesacViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 16
        let textAreaHeight: CGFloat = 124

        let width: CGFloat = (collectionView.bounds.width - itemSpacing) / 2
        let height: CGFloat = width + textAreaHeight
        return CGSize(width: width, height: height)
    }
}
