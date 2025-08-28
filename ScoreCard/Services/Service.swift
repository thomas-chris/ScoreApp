protocol Service<T> {
    
    associatedtype T
    
    func insert(_ item: T)
    func delete(_ item: T)
    func fetchData() -> [T]
}
