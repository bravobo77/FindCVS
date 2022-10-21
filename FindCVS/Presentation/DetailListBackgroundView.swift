//
//  DetailListBackgroundView.swift
//  FindCVS
//
//  Created by 金　甫硬 on 2022/10/21.
//

import RxSwift
import RxCocoa

/*
 
 아무것도 가지고 오지 못했을 때 보이는 뷰, 백그라운드 뷰
 can't take any values then show this background view.
 
 */

class DetailListBackgroundView: UIView {
    let disposBag = DisposeBag()
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailListBackgroundViewModel) {
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposBag)
    }
    
    private func attribute() {
        backgroundColor = .white
        
        statusLabel.text = "🏪"
        statusLabel.textAlignment = .center
    }
    
    private func layout() {
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
