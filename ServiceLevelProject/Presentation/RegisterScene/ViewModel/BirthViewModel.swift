//
//  BirthViewModel.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/22.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

typealias BirthInfo = (String?, String?, String?)

final class BirthViewModel: ViewModelType {

    private weak var coordinator: BirthCoordinator?

    struct Input {
        let didSelectedDatePicker: Signal<Date>
        let didNextButtonTap: Signal<BirthInfo>
    }
    struct Output {
        let isValid: Driver<Bool>
        let yearText: Signal<String>
        let monthText: Signal<String>
        let dayText: Signal<String>
        let showToastAction: Signal<String>
    }
    var disposeBag = DisposeBag()

    private let isValid = BehaviorRelay<Bool>(value: false)
    private let yearText = PublishRelay<String>()
    private let monthText = PublishRelay<String>()
    private let dayText = PublishRelay<String>()
    private let showToastAction = PublishRelay<String>()

    private var selectedDate = Date()

    init(coordinator: BirthCoordinator?) {
        self.coordinator = coordinator
    }

    func transform(input: Input) -> Output {

        input.didSelectedDatePicker
            .emit(onNext: { [weak self] date in
                guard let self = self else { return }
                self.selectedDate = date
                let arr = self.dateTransform(date: date)
                self.yearText.accept(arr[0])
                self.monthText.accept(arr[1])
                self.dayText.accept(arr[2])
                self.isValid.accept(true)
            })
            .disposed(by: disposeBag)

        input.didNextButtonTap
            .map(validationDate)
            .emit(onNext: { [weak self] isValidBirth in
                guard let self = self else { return }
                if isValidBirth {
                    self.saveBirthInfo()
                    self.coordinator?.connectEmailCoordinator()
                }
            })
            .disposed(by: disposeBag)

        return Output(
            isValid: isValid.asDriver(),
            yearText: yearText.asSignal(),
            monthText: monthText.asSignal(),
            dayText: dayText.asSignal(),
            showToastAction: showToastAction.asSignal()
        )
    }
}

extension BirthViewModel {

    private func saveBirthInfo() {
        UserDefaults.standard.set(self.selectedDate, forKey: UserDefaultKeyCase.birth)
    }

    private func dateTransform(date: Date) -> [String] {
        let dateString = dateToString(date: date)
        let arr = dateString.components(separatedBy: " ")
        return arr
    }

    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy MM dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    private func validationDate(year: String?, month: String?, day: String?) -> Bool {
        guard let year = year, year != "", let month = month, let day = day else {
            self.showToastAction.accept("날짜를 입력해주세요.")
            return false
        }
        guard Int(year) != nil, Int(month) != nil, Int(day) != nil else {
            self.showToastAction.accept("올바른 날짜 형식이 아닙니다.")
            return false
        }
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko-KR")
        guard let add17YearsDate = calendar.date(byAdding: .year, value: 17, to: selectedDate) else {
            self.showToastAction.accept("올바른 날짜 형식이 아닙니다.")
            return false
        }
        if Date() < add17YearsDate {
            self.showToastAction.accept("만 17세 이상만 가입할 수 있습니다.")
            return false
        }
        return true
    }
}
