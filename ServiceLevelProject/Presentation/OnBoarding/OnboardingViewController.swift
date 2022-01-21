//
//  OnboardingViewController.swift
//  ServiceLevelProject
//
//  Created by meng on 2022/01/20.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private let descriptionLabel = UILabel()
    private let startButton = DefaultFillButton(title: "시작하기")

    private let onBoardingImageViews: [UIImage] = [
        Asset.onBoarding1.image,
        Asset.onBoarding2.image,
        Asset.onBoarding3.image
    ]

    private let mutableAttributedStrings: [NSMutableAttributedString] = [
        NSMutableAttributedString()
            .greenHighlight(string: "위치 기반")
            .regular(string: "으로 빠르게\n주위 친구를 확인"),
        NSMutableAttributedString()
            .greenHighlight(string: "관심사가 같은 친구")
            .regular(string: "를\n찾을 수 있어요"),
        NSMutableAttributedString()
            .regular(string: "SeSAC Freinds")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        setConfigurations()
    }

    private func setViews() {
        view.addSubview(scrollView)
        view.addSubview(startButton)
        view.addSubview(pageControl)
        view.addSubview(descriptionLabel)
    }

    private func setConstraints() {

        scrollView.frame = view.bounds

        for i in 0..<onBoardingImageViews.count {
            let scrollContentView = UIView()
            scrollView.addSubview(scrollContentView)
            let xPos = self.view.frame.width * CGFloat(i)
            scrollContentView.frame = CGRect(x: xPos,
                                             y: 0,
                                             width: scrollView.bounds.width,
                                             height: scrollView.bounds.height)

            let imageView = UIImageView()
            imageView.image = onBoardingImageViews[i]
            scrollContentView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview().multipliedBy(1.1)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.height.equalTo(imageView.snp.width)
            }
            imageView.contentMode = .scaleAspectFill
            scrollView.contentSize.width = scrollContentView.frame.width * CGFloat(i + 1)
        }

        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(-42)
            make.height.equalTo(30)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    private func setConfigurations() {
        view.backgroundColor = .white
        startButton.addTarget(self, action: #selector(startButtonTap), for: .touchUpInside)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        pageControl.numberOfPages = onBoardingImageViews.count
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray5

        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = mutableAttributedStrings[0]
    }

    @objc
    private func startButtonTap() {

    }
}

extension OnboardingViewController: UIScrollViewDelegate {

    //스크롤 할 때 일어나는 일
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let value = targetContentOffset.pointee.x / scrollView.frame.size.width
        let currentPageNumber = Int(value)
        descriptionLabel.attributedText = mutableAttributedStrings[currentPageNumber]
        setPageControlSelectedPage(currentPage: currentPageNumber)
    }

    //페이지 컨트롤 표시
    private func setPageControlSelectedPage(currentPage: Int){
        self.pageControl.currentPage = currentPage
    }
}
