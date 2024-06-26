//
//  CrewContentViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CrewContentViewController: BaseViewController<CrewContentView> {
    
    let viewModel = CrewContentViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        
        // introduce 확장 버튼 클릭
        layoutView.expandButton.rx.tap
            .bind(with: self) { owner, _ in
                
                owner.layoutView.expandScrollView()
                owner.layoutView.setExpandScrollView(isHidden: true)
                
            }.disposed(by: disposeBag)
        
        // Page VC Embedded
        Observable.zip(viewModel.postData, viewModel.userData)
            .bind(with: self) { owner, data in
                
                let (postData, userData) = data
                
                owner.layoutView.configure(postData)
                
                let pageVC = ContentPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                
                self.addChild(pageVC)
                owner.layoutView.containerView.addSubview(pageVC.view)
                
                pageVC.view.frame = owner.layoutView.containerView.bounds
                pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                // Post Data 전달
                pageVC.viewModel.postData.accept(postData)
                pageVC.viewModel.userData.accept(userData)
                
                // 페이지 Delegate 설정
                pageVC.pageDelegate = self
                
                pageVC.didMove(toParent: self)
            }.disposed(by: disposeBag)
        
        // Collection View
        viewModel.category
            .bind(to: layoutView.contentCollectionView.rx.items(cellIdentifier: CrewContentCollectionViewCell.identifier,
                                                                cellType: CrewContentCollectionViewCell.self)) { [weak self] index, data, cell in
                
                guard let self else { return }
                
                cell.setTitle(data)
                cell.configure(isSelected: index == self.viewModel.selected)
                
            }.disposed(by: disposeBag)
        
        // Cell 클릭
        layoutView.contentCollectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                
                owner.viewModel.newSelected.accept(indexPath.row)
            }.disposed(by: disposeBag)
        
        // Selected 변경 시
        viewModel.isNext
            .bind(with: self) { owner, isNext in
                
                guard let vc = self.children.first, let pageVC = vc as? ContentPageViewController  else {return }
                let selected = owner.viewModel.selected
                
                let selectedVC = pageVC.pages[selected]
                
                pageVC.setViewControllers([selectedVC],
                                          direction: isNext ? .forward : .reverse,
                                          animated: true)
                pageVC.viewModel.selectedPage.accept(selected)
                
                owner.layoutView.contentCollectionView.reloadData()
                
            }.disposed(by: disposeBag)
    }
    
    override func configureCollectionView() {
        
        layoutView.contentCollectionView.isScrollEnabled = false
        layoutView.contentCollectionView.register(CrewContentCollectionViewCell.self, forCellWithReuseIdentifier: CrewContentCollectionViewCell.identifier)
    }
}

extension CrewContentViewController: PageDelegate {
    
    func nextComplete(_ index: Int) {
        
        viewModel.newSelected.accept(index)
    }
    
    func previousComplete(_ index: Int) {
        
        viewModel.newSelected.accept(index)
    }
}
