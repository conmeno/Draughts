struct Set<T: Hashable> {
    private var dictionary = Dictionary<T, Bool>()
    
    mutating func addElement(newElement: T) {
        dictionary[newElement] = true
    }
    
    mutating func removeElement(element: T) {
        dictionary[element] = nil
    }
    
    func containsElement(element: T) -> Bool {
        return dictionary[element] != nil
    }
    
    func allElement() -> [T] {
        return Array(dictionary.keys)
    }
    
    func isEmpty() -> Bool {
        return dictionary.isEmpty
    }
}

extension Set: SequenceType {
    func generate() -> IndexingGenerator<Array<T>> {
        return allElement().generate()
    }
}
