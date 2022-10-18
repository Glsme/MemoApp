//
//  MemoListViewController.swift
//  MemoApp
//
//  Created by Seokjune Hong on 2022/08/31.
//

import UIKit
import RealmSwift

class MemoPreViewController: BaseViewController {
    
    var memoList: [UserMemo] = []
    let mainView = MemoPreView()
    
    override func loadView() {
        self.view = mainView
    }
    
    var tasks: Results<UserMemo>! {
        didSet {
            mainView.memoListCollectionView.reloadData()
        }
    }
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, UserMemo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasks = UserMemoRepository.shared.fetch()
        memoList = tasks.filter { $0.pin == false }
        
        mainView.memoListCollectionView.dataSource = self
        mainView.memoListCollectionView.delegate = self
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .purple
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()  //cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.memoTitle
            content.textProperties.color = .purple
            
            content.secondaryText = itemIdentifier.memoContent
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 20
            
            content.imageProperties.tintColor = .darkGray
            
            cell.contentConfiguration = content
        }
    }
}

extension MemoPreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        memoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = memoList[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
    }
    
    
}
