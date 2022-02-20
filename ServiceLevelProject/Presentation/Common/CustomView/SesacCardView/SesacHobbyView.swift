//
//  SesacHobbyView.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/14.
//

import UIKit
import RxCocoa
import RxSwift

final class SesacHobbyView: UIView, UIScrollViewDelegate {

    private let titleLabel = DefaultLabel(title: "하고 싶은 취미", font: .title4R14)

    lazy var collectionView: DynamicCollectionView = {
        let layout = CollectionViewLeftAlignFlowLayout()
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    let hobbyLists = PublishRelay<[String]>()
    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigurations()
        setConstraints()
        bind()
    }

    required init(coder: NSCoder) {
        fatalError("SesacReviewView: fatal error")
    }

    private func bind() {
        self.hobbyLists
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: NearHobbyCell.identifier, cellType: NearHobbyCell.self)) { index, hobby, cell in
                if hobby == "anything" || hobby == "Anything" {
                    cell.updateUI(hobby: "아무거나")
                } else {
                    cell.updateUI(hobby: hobby)
                }
            }
            .disposed(by: disposeBag)
    }

    private func setConstraints() {
        addSubview(titleLabel)
        addSubview(collectionView)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            //make.height.equalTo(100).priority(.low)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    private func setConfigurations() {
        collectionView.register(NearHobbyCell.self,
                                forCellWithReuseIdentifier: NearHobbyCell.identifier)
        titleLabel.textAlignment = .left
        collectionView.isScrollEnabled = false
    }
}
