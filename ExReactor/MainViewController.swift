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


enum MainSectionItem {
    case event(String)
    case banner(Int)
}


struct MainSectionModel {
    var items:[MainSectionItem]
}

extension MainSectionModel : SectionModelType {
    typealias Item = MainSectionItem
    
    init(original: MainSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}


class MainViewController: UIViewController, View {
     
    var disposeBag: DisposeBag
    typealias Reactor = MainViewReactor
    
    lazy var listView = UICollectionView().then {
        $0.collectionViewLayout = self.createLayout()
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
       
       
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.listView.pin.all()
        
    }
    private func createLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
//                let section = self.sections[sectionIndex]
                
                // Item 설정
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // Group 설정
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
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
    
    func sample() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MainSectionModel> { source, view, indexPath, item in
            return UICollectionViewCell()
           }
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
           return RxCollectionViewSectionedReloadDataSource<MainSectionModel>(
               configureCell: { dataSource, collectionView, indexPath, item in
                   
                   
                   switch item {
                   case .event(let model):
                       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextCell", for: indexPath) as! TextCell
                       
                       return cell
                   case .banner(let model):
                       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
                       
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
        
  
        reactor.state.map{$0.listData}.bind(to: listView.rx.items(dataSource: self.sample())).disposed(by: disposeBag)
        
    }
 

}
