import Foundation

protocol Service<T> {
    
    associatedtype T
    
    func insert(_ item: T)
    func delete(_ item: T)
    func delete(with id: UUID)
    func fetchData() -> [T]
}
