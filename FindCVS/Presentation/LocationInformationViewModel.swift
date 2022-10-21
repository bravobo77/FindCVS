//
//  LocationInformationViewModel.swift
//  FindCVS
//
//  Created by 金　甫硬 on 2022/10/19.
//

import RxSwift
import RxCocoa

struct LocationInformationViewModel {
    let disposeBag = DisposeBag()
    
    // subViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    //viewModel -> view
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    let detailListCellData: Driver<[DetailListCellData]>
    let scrollToSelectedLocation: Signal<Int>
    
    //view -> viewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()
    
    // 가져고 온 데이터 값중에서 seleted row 값을 뽑아낼 수 있다
    let documentData = PublishSubject<[KLDocument]>()
    
    init() {
        // MARK: 지도 중심점 설정
        
        let selectedDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map { data -> MTMapPoint in
                guard let data = data,
                      let longtitude = Double(data.x),
                      let latitude = Double(data.y) else { return MTMapPoint() }
                
                let geoCoord = MTMapPointGeo(latitude: latitude, longitude: longtitude)
                return MTMapPoint(geoCoord: geoCoord)
            }
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                // list를 선택했거나,
                selectedDetailListItem,
                // 최초의 로케이션 값이나,
                currentLocation.take(1),
                // 버튼을 눌러서 현재위치로 이동했을 때
                   moveToCurrentLocation
                // 이동할 수 있도록
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시후 다시 시도해주세요.")
    }
}
