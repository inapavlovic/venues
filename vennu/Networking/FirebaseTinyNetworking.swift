//
//  FirebaseTinyNetworking.swift
//  vennu
//
//  Created by Ina Statkic on 01/11/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FirebaseResource<A> {
    var reference: DatabaseQuery
    let decode: (DataSnapshot) -> A
}

extension FirebaseResource where A: Decodable {
    init(reference: DatabaseQuery) {
        self.reference = reference
        self.decode = { dataSnapshot in
            let data = try! JSONSerialization.data(withJSONObject: dataSnapshot.value!, options: .prettyPrinted)
            return try! JSONDecoder().decode(A.self, from: data)
        }
    }
}

extension FirebaseManager {
    func observe<A>(_ resource: FirebaseResource<A>, completion: @escaping([A]) -> ()) {
        resource.reference.observe(.value) { dataSnapshot in
            guard let dataSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            let items = dataSnapshot.compactMap(resource.decode)
            completion(items)
        }
    }
    
    func singleObserve<A>(_ resource: FirebaseResource<A>, completion: @escaping([A]) -> ()) {
        resource.reference.observeSingleEvent(of: .value) { dataSnapshot in
            guard let dataSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            let items = dataSnapshot.compactMap(resource.decode)
            completion(items)
        }
    }
    
    func observe<A>(_ resource: FirebaseResource<A>, completion: @escaping(A) -> ()) {
        resource.reference.observe(.value) { dataSnapshot in
            let item = resource.decode(dataSnapshot)
            completion(item)
        }
    }
    
    func singleObserve<A>(_ resource: FirebaseResource<A>, completion: @escaping(A) -> ()) {
        resource.reference.observeSingleEvent(of: .value) { dataSnapshot in
            let item = resource.decode(dataSnapshot)
            completion(item)
        }
    }
}
