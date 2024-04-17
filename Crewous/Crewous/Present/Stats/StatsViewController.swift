//
//  StatsViewController.swift
//  Crewous
//
//  Created by 이중엽 on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa

class StatsViewController: BaseViewController<StatsView> {
    
    let viewModel = StatsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        layoutView.indicator.startAnimating()
    }
    
    override func bind() {
        super.bind()
        
        let viewWillAppearObservable = self.rx.viewWillAppear
        
        let input = StatsViewModel.Input(viewWillAppearObservable: viewWillAppearObservable)
        let output = viewModel.transform(input: input)
        
        // 유저 정보 불러오기 성공
        
        Observable.zip(output.fetchSelfSuccess, output.fetchCrewSuccess)
            .bind(with: self) { owner, datas in
                
                owner.layoutView.indicator.stopAnimating()
                
                let (fetchSelfData, fetchCrewData) = datas
                dump(fetchCrewData)
                
                let mappingData: [String] = fetchSelfData.nick.split(separator: "/").map { String($0) }
                let nick = mappingData[0]
                let height = mappingData[1]
                let weight = mappingData[2]
                let position = mappingData[3]
                
                owner.layoutView.nickLabel.text = nick
                owner.layoutView.heightInfoLabel.text = "\(height)CM"
                owner.layoutView.weightInfoLabel.text = "\(weight)KG"
                owner.layoutView.positionInfoLabel.text = position
                
                guard let crewData = fetchCrewData.data.first else {
                    UDManager.isJoinedCrew = false
                    return
                }
                
                UDManager.isJoinedCrew = true
                
                owner.layoutView.crewLabel.text = "Crew - \(crewData.title)"
                owner.layoutView.crewInfoLabel.text = crewData.title
                
            }.disposed(by: disposeBag)
        
        // 유저 정보 불러오기 실패
        output.fetchFailure.bind(with: self) { owner, apiError in
            
            owner.layoutView.indicator.stopAnimating()
            
            // 재호출
            owner.errorHandler(apiError, calltype: .fetchSelf) {
                owner.viewWillAppear(true)
            }
        }.disposed(by: disposeBag)
        
        
        
        // 탈퇴(테스트)
        layoutView.withDrawButton.rx.tap
            .flatMap {
                
                return APIManager.callAPI(router: Router.withDraw, dataModel: WithDrawDataModel.self)
            }.subscribe(with: self) { owner, result in
                
                switch result {
                    
                case .success(let data):
                    dump(data)
                    owner.makeAlert(msg: "탈퇴 완료") { [weak self] _ in
                        
                        guard let self else { return }
                        
                        owner.changeRootViewToSignIn()
                    }
                    
                case .failure(_):
                    print("fail")
                }
            }.disposed(by: disposeBag)
    }
}
