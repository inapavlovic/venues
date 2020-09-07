//
//  FirebaseManager.swift
//  vennu
//
//  Created by Ina Statkic on 08/09/2020.
//  Copyright © 2020 Ina. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseStorage
import FBSDKLoginKit

final class FirebaseManager {
    
    // MARK: Properties
    
    static let shared = FirebaseManager()
    static let databaseRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
    
    let fbLoginManager = LoginManager()
    
    var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    var uid: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    var name: String {
        return Auth.auth().currentUser?.displayName ?? ""
    }
    
    var email: String {
        return Auth.auth().currentUser?.email ?? ""
    }
    
    // MARK: - Endpoints
    
    enum Endpoint {
        static let app = databaseRef.child("app_url")
        static let users = databaseRef.child("users")
        static let venues = databaseRef.child("venues")
        static let photos = storageRef.child("photos")
        static let bookings = databaseRef.child("bookings")
        static let catering = databaseRef.child("catering")
        static let fee = databaseRef.child("booking_fee")
        static let activities = databaseRef.child("activities")
    }
}

// MARK: - App

extension FirebaseManager {
    func appURL(completion: @escaping (URL?) -> ()) {
        Endpoint.app.observeSingleEvent(of: .value) { dataSnapshot in
            guard let dict = dataSnapshot.value as? [String: String] else {
                completion(nil)
                return
            }
            
            guard let url = URL(string: dict["iOS"] ?? "") else {
                completion(nil)
                return
            }
            completion(url)
        }
    }
    
    func document(_ document: String, completion: @escaping (Data?) -> ()) {
        let termsConditionsRef = FirebaseManager.storageRef.child(document)
        termsConditionsRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                completion(data)
            }
        }
    }
}

// MARK: - Auth

extension FirebaseManager {
    func signIn(_ auth: Authentication, completion: @escaping (Error?) -> ()) {
        Auth.auth().signIn(withEmail: auth.email!, password: auth.password!) { (authResult, error) in
            if let error = error {
                debugPrint("Error Signing in: \(error.localizedDescription)")
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func signUp(_ auth: Authentication, _ role: User.Role, completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: auth.email!, password: auth.password!) { (authResult, error) in
            if let error = error {
                completion(error)
            } else {
                let user = authResult?.user.createProfileChangeRequest()
                user?.displayName = auth.name
                user?.commitChanges(completion: { error in
                    if let error = error {
                        completion(error)
                    }
                })
                guard let uid = authResult?.user.uid else { return }
                switch role {
                case .pro:
                    Endpoint.users.child(uid).setValue([
                        "uid" : uid,
                        "role": role.rawValue,
                        "name" : auth.name!,
                        "businessName" : auth.businessName!,
                        "companyID" : auth.companyID!,
                        "phoneNumber" : auth.phoneNumber!,
                        "address" : auth.address!,
                        "email" : auth.email!
                    ]) { (error, databaseRef) in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                case .user:
                    Endpoint.users.child(uid).setValue([
                         "uid" : uid,
                         "role": role.rawValue,
                         "name" : auth.name!,
                         "email" : auth.email!
                    ]) { (error, databaseRef) in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                case .admin: break
                }
            }
        }
    }
    
    func verifyPhoneNumber(_ auth: Authentication, completion: @escaping (Error?) -> ()) {
        let phoneNumber = String(format: "+%@", auth.phoneNumber!)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(error)
            } else {
                UserDefaults.standard.set(verificationID, forKey: "phoneVerificationID")
                completion(nil)
            }
        }
    }
    
    func linkPhoneWithAccount(_ auth: Authentication, completion: @escaping (Error?) -> ()) {
        guard let verificationID = UserDefaults.standard.string(forKey: "phoneVerificationID") else { return }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: auth.verificationCode!)
        Auth.auth().currentUser?.link(with: credential, completion: { (authDataResult, error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        })
    }
    
    func signOut(completion: @escaping (Error?) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
            completion(error)
        }
    }
    
    func signInWith(_ credential: AuthCredential, _ role: User.Role, _ name: String? = nil, completion: @escaping (Error?) -> ()) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                debugPrint("Error Signing in: \(error.localizedDescription)")
                completion(error)
            } else {
                debugPrint("Credential provided")
                guard let uid = authResult?.user.uid else { return }
                Endpoint.users.observeSingleEvent(of: .value) { dataSnapshot in
                    if dataSnapshot.hasChild(uid) {
                        completion(nil)
                    } else {
                        Endpoint.users.child(uid).setValue([
                            "uid" : uid,
                            "role" : role.rawValue,
                            "name" : Auth.auth().currentUser?.displayName ?? name,
                            "email" : Auth.auth().currentUser?.email ?? ""
                        ]) { (error, databaseRef) in
                            if let error = error {
                                completion(error)
                            } else {
                                completion(nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fbSignIn(currentController: UIViewController, _ role: User.Role, completion: @escaping (Error?) -> (), cancelled: @escaping (Bool) -> ()) {
        fbLoginManager.logIn(permissions: [.email, .publicProfile], viewController: currentController) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .cancelled: debugPrint("Facebook sign in was cancelled"); cancelled(true)
            case .failed(let error): completion(error)
            case .success(granted: _, declined: _, token: let token):
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                GraphRequest(graphPath: "me", parameters: ["fields" : "email, name"]).start { (graphRequestConnection, result, error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    } else if let result = result as? [String : Any] {
                        let fbName = result["name"] as? String
                        // Commit changes to Firebase profile change request
                        let profileChangeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        profileChangeRequest?.displayName = fbName ?? ""
                        profileChangeRequest?.commitChanges()
                    }
                }
                self.signInWith(credential, role) { (error) in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    func signOutSocial() {
        guard let user = Auth.auth().currentUser else { return }
        for info in user.providerData {
            if info.providerID == FacebookAuthProviderID {
                fbLoginManager.logOut()
            }
        }
    }
    
    func sendPasswordResetWithEmail(_ email: String, completion: @escaping (Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}

// MARK: - User

extension FirebaseManager {
    func role(for email: String, completion: @escaping (User.Role?) -> ()) {
        Endpoint.users.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { dataSnapshot in
            guard let dataSnapshot = dataSnapshot.children.allObjects as? [DataSnapshot] else { return }
            guard let dict = dataSnapshot.first?.value as? [String: Any] else { return }
            do {
                let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(user.role)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func userBy(_ uid: String, completion: @escaping (User?) -> ()) {
        Endpoint.users.child(uid).observeSingleEvent(of: .value) { dataSnapshot in
            if let dict = dataSnapshot.value as? [String: Any] {
                do {
                    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    let user = try JSONDecoder().decode(User.self, from: data)
                    completion(user)
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
    
    func completeUser(_ uid: String, _ auth: Authentication, _ role: User.Role, completion: @escaping () -> ()) {
        switch role {
        case .pro:
            Endpoint.users.child(uid).updateChildValues([
                "businessName" : auth.businessName!,
                "companyID" : auth.companyID!,
                "phoneNumber" : auth.phoneNumber!,
                "address" : auth.address!
            ]) { (error, _) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    completion()
                }
            }
        case .user:
            Endpoint.users.child(uid).updateChildValues([
                "phoneNumber" : auth.phoneNumber!
            ]) { (error, _) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    completion()
                }
            }
        case .admin: break
        }
    }
    
    func customerUser(_ uid: String, customerId: String, completion: @escaping () -> ()) {
        Endpoint.users.child(uid).updateChildValues(["customerId" : customerId]) { (error, _) in
           if let error = error {
               debugPrint(error.localizedDescription)
           } else {
               completion()
           }
        }
    }
    
    func notifications(notify: Bool, completion: @escaping(Error?) -> ()) {
        Endpoint.users.child(uid).updateChildValues(["notifications" : notify]) { error, _ in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func notifications(completion: @escaping(Bool) -> ()) {
        Endpoint.users.child(uid).child("notifications").observe(.value) { dataSnapshot in
            if let status = dataSnapshot.value as? Bool {
                completion(status)
            }
        }
    }
    
}

// MARK: - Venue

extension FirebaseManager {
    private func download(ref: StorageReference, completion: @escaping (URL?) -> ()) {
        ref.downloadURL { (url, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                completion(url)
            }
        }
    }
    
    private func upload(id: String, photo: UIImage, completion: @escaping (Error?, String?) -> ()) {
        let storageRef = Endpoint.photos.child(uid).child(id).child("\(UUID().uuid).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        guard let data = photo.jpegData(compressionQuality: 1) else {
            completion(nil, nil)
            return
        }
        storageRef.putData(data, metadata: metaData, completion: { (_, error) in
            if error != nil {
                completion(error, nil)
            } else {
                storageRef.downloadURL(completion: { (url, error) in
                    completion(error, url?.absoluteString)
                })
            }
        })
    }
    
    func addVenue(request: VenueRequest, completion: @escaping(Error?) -> ()) {
        guard let autoId = Endpoint.venues.childByAutoId().key else { return }
        writeVenue(id: autoId, request: request, completion: completion)
    }
    
    func updateVenue(id: String, request: VenueRequest, completion: @escaping(Error?) -> ()) {
        writeVenue(id: id, request: request, completion: completion)
    }
    
    private func writeVenue(id: String, request: VenueRequest, completion: @escaping(Error?) -> ()) {
        var venue: [String: Any] = [
            "id" : id,
            "uid" : uid,
            "title" : request.title,
            "address" : request.address,
            "location" : request.location
        ]
        let group = DispatchGroup()
        var photos = [String]()
        for photo in request.photos {
            group.enter()
            self.upload(id: id, photo: photo) { (error, imageURLString) in
                if let error = error {
                    completion(error)
                    group.leave()
                } else {
                    if let image = imageURLString {
                        photos.append(image)
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main) {
            Endpoint.venues.child(id).updateChildValues([
                "photos" : photos
            ]) { (error, databaseRef) in
                if let error = error {
                    completion(error)
                }
            }
        }
        if let description = request.description { venue["description"] = description }
        if let features = request.features { venue["features"] = features }
        if let facilities = request.facilities { venue["facilities"] = facilities }
        var capacity: [String: Any] = [:]
        if let numberOfPeople = request.capacity {
            capacity["standing"] = numberOfPeople.standing
            capacity["theatre"] = numberOfPeople.theatre
            capacity["dining"] = numberOfPeople.dining
            capacity["boardroom"] = numberOfPeople.boardroom
            capacity["uShaped"] = numberOfPeople.uShaped
        }
        var pricing: [String: Any] = [:]
        if let price = request.pricing {
            pricing["hourly"] = price.hourly
            pricing["halfDay"] = price.halfDay
            pricing["fullDay"] = price.fullDay
            pricing["multiDay"] = price.multiDay
        }
        Endpoint.venues.child(id).updateChildValues(venue) { (error, databaseRef) in
            if let error = error {
                completion(error)
            } else {
                Endpoint.venues.child(id).child("capacity").updateChildValues(capacity) { (error, databaseRef) in
                    if let error = error {
                        completion(error)
                    }
                }
                Endpoint.venues.child(id).child("pricing").updateChildValues(pricing) { (error, databaseRef) in
                    if let error = error {
                        completion(error)
                    }
                }
                completion(nil)
            }
        }
    }
    
    func userVenues(completion: @escaping([Venue]) -> ()) {
        let resource = FirebaseResource<Venue>(reference: Endpoint.venues.queryOrdered(byChild: "uid").queryEqual(toValue: uid))
        observe(resource, completion: completion)
    }
    
    func venues(completion: @escaping([Venue]) -> ()) {
        let resource = FirebaseResource<Venue>(reference: Endpoint.venues)
        observe(resource, completion: completion)
    }
    
    func popularVenues(completion: @escaping([Venue]) -> ()) {
        let resource = FirebaseResource<Venue>(reference: Endpoint.venues.queryOrdered(byChild: "popular").queryEqual(toValue: true))
        observe(resource, completion: completion)
    }
    
    func locationVenues(query: String, completion: @escaping([Venue]) -> ()) {
        let resource = FirebaseResource<Venue>(reference: Endpoint.venues.queryOrdered(byChild: "location").queryStarting(atValue: query).queryEnding(atValue: query + "\\uf8ff"))
        observe(resource, completion: completion)
    }
    
    func arrangeVenues(completion: @escaping([Venue]) -> ()) {
        let resource = FirebaseResource<Venue>(reference: Endpoint.venues.queryOrdered(byChild: "pricing/hourly"))
        observe(resource, completion: completion)
    }
    
    func venue(id: String, completion: @escaping(Venue) -> ()) {
        let resource = FirebaseResource<Venue>(reference: Endpoint.venues.child(id))
        observe(resource, completion: completion)
    }
    
    func venueSingle(id: String, completion: @escaping(Venue) -> ()) {
        let resource = FirebaseResource<Venue>(reference: Endpoint.venues.child(id))
        singleObserve(resource, completion: completion)
    }
    
    // MARK: - Review & Rate
    
    func reviews(forVenue id: String, completion: @escaping([Review]) -> ()) {
        let resource = FirebaseResource<Review>(reference: Endpoint.venues.child(id).child("reviews"))
        singleObserve(resource, completion: completion)
    }
    
    func write(review text: String, venue id: String, completion: @escaping(Error?) -> ()) {
        let review: [String: Any] = [
            "author": name,
            "text": text
        ]
        reviews(forVenue: id) { reviews in
            Endpoint.venues.child(id).child("reviews/\(reviews.count)").updateChildValues(review) {
                (error, databaseRef) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func rates(forVenue id: String, completion: @escaping([Rate]) -> ()) {
        let resource = FirebaseResource<Rate>(reference: Endpoint.venues.child(id).child("rates"))
        singleObserve(resource, completion: completion)
    }
    
    func rate(_ rating: Int, venue id: String, completion: @escaping(Error?) -> ()) {
        let rate: [String: Any] = [
            "name": name,
            "stars": rating
        ]
        rates(forVenue: id) { rates in
            Endpoint.venues.child(id).child("rates/\(rates.count)").updateChildValues(rate) {
                (error, databaseRef) in
                if let error = error {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
}

// MARK: - Activity - Assistance

extension FirebaseManager {
    func requestAssistance(at venue: Venue, completion: @escaping(Error?) -> ()) {
        guard let autoId = Endpoint.activities.childByAutoId().key else { return }
        let request: [String: Any] = [
            "id": autoId,
            "customer": name,
            "userId": uid,
            "uidVenue": venue.uid,
            "venueId": venue.id,
            "title": venue.title,
            "time": Date().timeIntervalSince1970
        ]
        Endpoint.activities.child(autoId).setValue(request) {
            (error, databaseRef) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func activities(completion: @escaping([Activity]) -> ()) {
        let resource = FirebaseResource<Activity>(reference: Endpoint.activities)
        observe(resource, completion: completion)
    }
}
// MARK: - Booking

extension FirebaseManager {
    func bookVenue(request: Booking, completion: @escaping(Error?) -> ()) {
        guard let autoId = Endpoint.venues.childByAutoId().key else { return }
        var booking: [String: Any] = [
            "id" : autoId,
            "uid" : uid,
            "customer" : name,
            "venueId" : request.venueId!,
            "uidVenue" : request.uidVenue!,
            "title" : request.title!,
            "startDate" : request.startDate!,
            "duration" : request.duration!,
            "rentPrice" : request.rentPrice!
        ]
        if let notes = request.notes {
            booking["notes"] = notes
        }
        var catering: [String: Any] = [:]
        if let numberOf = request.catering {
            catering["basic"] = numberOf.basic
            catering["premium"] = numberOf.premium
        }
        Endpoint.bookings.child(autoId).updateChildValues(booking) { (error, databaseRef) in
            if let error = error {
                completion(error)
            } else {
                Endpoint.bookings.child(autoId).child("catering").updateChildValues(catering) { (error, databaseRef) in
                    if let error = error {
                        completion(error)
                    }
                }
                completion(nil)
            }
        }
    }
    
    func userBookings(completion: @escaping([Booking]) -> ()) {
        let resource = FirebaseResource<Booking>(reference: Endpoint.bookings.queryOrdered(byChild: "userId").queryEqual(toValue: uid))
        observe(resource, completion: completion)
    }
    
    func bookings(completion: @escaping([Booking]) -> ()) {
        let resource = FirebaseResource<Booking>(reference: Endpoint.bookings.queryOrdered(byChild: "uidVenue").queryEqual(toValue: uid))
        observe(resource, completion: completion)
    }
    
    func bookedUserVenues(completion: @escaping([Venue], [Venue], [Venue]) -> ()) {
        let group = DispatchGroup()
        userBookings { bookings in
            var pastVenues = [Venue]()
            var upcomingVenues = [Venue]()
            var startedVenues = [Venue]()
            for booking in bookings {
                group.enter()
                self.venueSingle(id: booking.venueId!) { venue in
                    let startDate = Date(timeIntervalSince1970: booking.startDate!)
                    let endDate = Date(timeIntervalSince1970: booking.endDate!)
                    if Date().daysHours(to: startDate) > (0, 0) {
                        upcomingVenues.append(venue)
                    } else if Date().daysHours(to: startDate) <= (0, 0) {
                        pastVenues.append(venue)
                        if Date().daysHours(to: endDate) > (0, 0) {
                            startedVenues.append(venue)
                        }
                    }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(upcomingVenues, pastVenues, startedVenues)
            }
        }
    }
    
    func catering(context: InfoContext, completion: @escaping (Double?) -> ()) {
        Endpoint.catering.observeSingleEvent(of: .value) { dataSnapshot in
            guard
                let dict = dataSnapshot.value as? [String: Double],
                let value = dict[context.rawValue]
            else {
                completion(nil)
                return
            }
            completion(value)
        }
    }
    
    func catering(completion: @escaping (CateringPrice) -> ()) {
        let resource = FirebaseResource<CateringPrice>(reference: Endpoint.catering)
        observe(resource, completion: completion)
    }
    
    func fee(completion: @escaping (Double?) -> ()) {
        Endpoint.fee.observeSingleEvent(of: .value) { dataSnapshot in
            guard let value = dataSnapshot.value else {
                completion(nil)
                return
            }
            completion(value as? Double)
        }
    }
    
    func catering(pricing: CateringPrice, completion: @escaping(Error?) -> ()) {
        let catering: [String: Any] = [
            "basic_info": pricing.basicInfo,
            "premium_info": pricing.premiumInfo,
            "basic": pricing.basic,
            "premium": pricing.premium
        ]
        Endpoint.catering.updateChildValues(catering) {
            (error, databaseRef) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func fee(value: Double, completion: @escaping(Error?) -> ()) {
        Endpoint.fee.setValue(value) {
            (error, databaseRef) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
