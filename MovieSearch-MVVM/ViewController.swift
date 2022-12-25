//
//  ViewController.swift
//  MovieSearch-MVVM
//
//  Created by Kiran Sonne on 19/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    let movieViewModel = MovieViewModel()
    var movieList: MovieListModel?
    var pageCount = 0
    var searchText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        moviesCollectionView.setCollectionViewLayout(layout, animated: true)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        
        movieSearchBar.delegate = self
        
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        moviesCollectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
     }


}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movieList?.search.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell
        else {
            return MovieCollectionViewCell()
        }
        guard let imgUrl = movieList?.search[indexPath.row].posterURL else {return MovieCollectionViewCell()}
        movieViewModel.loadImage(url: imgUrl) { img in
            cell.configure(img: img)
        }
        return cell
    }
    
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height: 250)
    }
    
}
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height)
        
        if endScrolling >= scrollView.contentSize.height {
            pageCount += 1
            print(pageCount)
            movieViewModel.getData(searchText: searchText,pageNo: pageCount) { movielist in
                let oldSearch = self.movieList?.search ?? []
                let combinedSearch = oldSearch + movielist.search
                let oldTotalResults = self.movieList?.totalResults
                let combinedResults = (oldTotalResults ?? "") + movielist.totalResults
                let oldTotalResponse = self.movieList?.response
                let combinedResponse = (oldTotalResponse ?? "") + movielist.response
                self.movieList = MovieListModel(search: combinedSearch, totalResults: combinedResults, response: combinedResponse)
            }
        }
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchText = searchText
            movieViewModel.getData(searchText: searchText, pageNo: 1) { movieList in
                self.movieList = movieList
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }
        }
    }
    
}
