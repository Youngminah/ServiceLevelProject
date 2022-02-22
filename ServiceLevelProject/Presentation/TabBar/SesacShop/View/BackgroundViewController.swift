//
//  BackgroundViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/02/20.
//

import UIKit
import RxCocoa
import RxSwift

final class BackgroundViewController: UIViewController {

    weak var delegate: PreviewSesacDeleagete?
    var backgroundCollection = [Int]()

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private lazy var input = BackgroundViewModel.Input(
        viewDidLoad: Observable.just(()),
        priceButtonTap: priceButtonTap.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let viewModel: BackgroundViewModel
    private let disposeBag = DisposeBag()

    private let priceButtonTap = PublishRelay<Int>()

    init(viewModel: BackgroundViewModel) {
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
        output.indicatorAction
            .drive(onNext: {
                $0 ? IndicatorView.shared.show(backgoundColor: Asset.transparent.color) : IndicatorView.shared.hide()
            })
            .disposed(by: disposeBag)

        output.backgroundLists
            .drive(tableView.rx.items) { [weak self] tv, index, item in
                guard let self = self else { return UITableViewCell() }
                let cell = tv.dequeueReusableCell(withIdentifier: BackgroundCell.identifier) as! BackgroundCell
                cell.updateUI(background: item, isHaving: self.backgroundCollection[index])
                cell.priceButton.rx.tap.asSignal()
                    .map { index }
                    .emit(to: self.priceButtonTap)
                    .disposed(by: cell.disposeBag)
                return cell
            }
            .disposed(by: disposeBag)

        output.successPurchaseProduct
            .emit(onNext: { [weak self] background in
                guard let self = self else { return }
                self.backgroundCollection[background.rawValue] = 1
                self.delegate?.transmitPurchaseBackgroundProduct(background: background)
                UIView.performWithoutAnimation {
                    self.tableView.reloadRows(at: [IndexPath(row: background.rawValue, section: 0)], with: .none)
                }
            })
            .disposed(by: disposeBag)

        tableView.rx.modelSelected(SesacBackgroundCase.self)
            .asSignal()
            .emit(onNext: { [weak self] item in
                self?.delegate?.updateBackground(background: item)
            })
            .disposed(by: disposeBag)
    }

    private func setViews() {
        view.addSubview(tableView)
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setConfigurations() {
        tableView.register(BackgroundCell.self, forCellReuseIdentifier: BackgroundCell.identifier)
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = 0
        tableView.rowHeight = UIScreen.main.bounds.width * ( 180 / 375.0 )
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        tableView.backgroundColor = .white
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 1
        }
    }
}
