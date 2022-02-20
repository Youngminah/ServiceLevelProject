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

    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let disposeBag = DisposeBag()

    private let sesacLists = BehaviorRelay<[SesacImageCase]>(value: SesacImageCase.allCases)

    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurations()
        setViews()
        bind()
        setConstraints()
    }

    private func bind() {
        self.sesacLists
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: SesacCell.identifier, cellType: SesacCell.self)) { index, sesac, cell in
                cell.updateUI(sesac: sesac)
            }
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
