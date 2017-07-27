import Leopard
import Lynx

public class Documentation {
    public private(set) static var `default` = Documentation(for: "")
    
    public internal(set) var documentation = [String: Documentation]()
    
    public var docs = ""
    public var examples = [Example]()
    
    public let component: String
    
    init(for component: String) {
        self.component = component
    }
}

public class Example {
    public var input: Request
    public var output: Response
    public var errors: [Response]
    
    public init(input: Request, output: Response, errors: [Response])  {
        self.input = input
        self.output = output
        self.errors = errors
    }
}

public final class CollectionDocumentation : Documentation { }

extension RoutingCollection {
    public func document(_ docgen: ((CollectionDocumentation) -> ())) {
        guard self.path.count > 0 else {
            return
        }
        
        var path = self.path
        
        let last = path.removeLast()
        
        let docs = CollectionDocumentation(for: last)
        
        docgen(docs)
        
        var documentation = Documentation.default
        
        var iterator = path.makeIterator()
        var components = [String]()
        
        while let component = iterator.next() {
            guard let docs = documentation.documentation[component] else {
                components.append(component)
                return
            }
            
            documentation = docs
        }
        
        while let component = iterator.next() {
            components.append(component)
        }
        
        for component in components {
            let newDocs = CollectionDocumentation(for: component)
            documentation.documentation[component] = newDocs
            documentation = newDocs
        }
        
        documentation.documentation[last] = docs
    }
}
