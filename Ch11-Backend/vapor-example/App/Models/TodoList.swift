import Vapor

final class TodoStore {
    
    static let sharedInstance = TodoStore()
    private var list: [Todo] = Array<Todo>()
    private init() {
    }
    
    func addOrUpdateItem(item: Todo) {
        if self.find(id: item.id) != nil {
            update(item: item)
        } else {
            self.list.append(item)
        }
    }
    
    func listItems() -> [Todo] {
        return self.list
    }
    
    func delete(id: Int) -> String {
        if self.find(id: id) != nil {
            self.list = self.list.filter { $0.id != id }
            return "Item is deleted"
        }
        return "Item not found"
    }
    
    func deleteAll() -> String {
        if self.list.count > 0 {
            self.list.removeAll()
            return "All items were deleted"
        }
        return "List was empty"
        
    }
    
    func update(item: Todo) -> String {
        if let index = (self.list.index { $0.id == item.id }) {
            self.list[index] = item
            return "item is up to date"
        }
        return "item not found"
    }
    
    func find(id: Int) -> Todo? {
        return self.list.index { $0.id == id }.map { self.list[$0] }
    }
}

/**
	This allows instances of User to be
	passed into Json arrays and dictionaries
	as if it were a native JSON type.
 */
extension TodoStore: JsonRepresentable {
    func makeJson() -> Json {
        return Json([
                        "list": "\(list)"
            ])
    }
}

///**
//	If a data structure is StringInitializable,
//	it's Type can be passed into type-safe routing handlers.
//*/
//extension Todo: StringInitializable {
//
////    convenience init?(from string: String) throws {
////        self.init(name: string, description: description, notes: notes, completed: completed)
////    }
////    convenience init?(from name: String) throws {
////        self.init(name: name, description: "", notes: "", completed: "")
////    }
//
//    convenience init?(from string: String) throws {
//        self.init(name: string)
//    }
//}