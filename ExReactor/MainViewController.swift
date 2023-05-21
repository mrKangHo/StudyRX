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
    
    lazy var listView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout()).then {
        $0.register(TextCell.self, forCellWithReuseIdentifier: "textCell")
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
    private func createLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                
                print("Section = \(sectionIndex) env = \(environment)")
                
                // Item 설정
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group 설정
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                group.interItemSpacing = .fixed(10)
                
                // Section 설정
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//                section.boundarySupplementaryItems = [self.createHeader()]
                
                return section
            }
            
            return layout
        }

    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
           return RxCollectionViewSectionedReloadDataSource<MainSectionModel>(
               configureCell: { dataSource, collectionView, indexPath, item in
                   switch item {
                   case .users(let users):
                       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textCell", for: indexPath) as! TextCell
                       cell.configure(users.maidenName)
                       return cell
                   case .products(let product):
                       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
                       cell.configure(product.title)
                       return cell
                   }
               },
               configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                   let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCell", for: indexPath)
//                   let section = dataSource[indexPath.section]
//                   cell.titleLabel.text = section.title
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
        
        
        self.listView.rx.itemSelected.map{ indexPath in Reactor.Action.choiceItems(indexPath)}.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.selectedItems}.subscribe { index in
            
        }
        
    }
 

}
