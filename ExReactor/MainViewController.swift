//
//  MainViewController.swift
//  ExReactor
//
//  Created by LEE on 2023/05/03.
//

import UIKit
import FlexLayout
import PinLayout
import ReactorKit
import RxCocoa
import RxDataSources
import Then




class MainViewController: UIViewController, View {
     
    var disposeBag: DisposeBag
    typealias Reactor = MainViewReactor
    
    lazy var listView = UICollectionView(frame: .zero, collectionViewLayout: MainLayout.create()).then {
        $0.register(TextCell.self, forCellWithReuseIdentifier: "TextCell")
        $0.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
    }
    
    
    init(_ reactor:MainViewReactor? = nil) {
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
        if reactor == nil {
            self.reactor = MainViewReactor()
        }
        else {
            self.reactor = reactor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(listView)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.listView.pin.all()
        
    }
    

    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
           return RxCollectionViewSectionedReloadDataSource<MainSectionModel>(
               configureCell: { dataSource, collectionView, indexPath, item in
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type(of: item).reuseId, for: indexPath)
                   item.configure(cell: cell)
                   return cell
               }
           )
       }

    func bind(reactor: MainViewReactor) {
        
        self.rx.viewDidLoad
            .map{Reactor.Action.load}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
  
        reactor.state.map{$0.listData}.bind(to: listView.rx.items(dataSource: self.createDataSource())).disposed(by: disposeBag)
        self.listView.rx.itemSelected.subscribe { indexPath in
            
            print("Section = \(indexPath.element?.section) Row = \(indexPath.element?.row)")
        }.disposed(by: disposeBag)
        
    }
 

}
