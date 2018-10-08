//
//  Database.swift
//  Rx_TubeApp
//
//  Created by 細田大志 on 2018/10/07.
//  Copyright © 2018 HIroshi Hosoda. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift



final class Database {
    
    static let shared = Database()
    
    private init() {}
    
    func config() {
        var realmConfig = Realm.Configuration()
        realmConfig.fileURL = realmConfig.fileURL?.deletingLastPathComponent().appendingPathComponent("RxTube.realm")
        Realm.Configuration.defaultConfiguration = realmConfig
    }
    
    func fetch<T: ConvertibleToModel, U>(type: T.Type) -> Maybe<U> where T: Object, T.M == U {
        
        return Maybe.create() { observer in
            do {
                let realm = try Realm()
                if let object = realm.objects(type).first {
                    observer(.success(object.toModel()))
                } else {
                    observer(.completed)
                }
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func fetchByPrimaryKey<T: ConvertibleToModel, U>(type: T.Type, primaryKey: String) -> Maybe<U> where T: Object, T.M == U {
        return Maybe.create() { observer in
            do {
                let realm = try Realm()
                if let object = realm.object(ofType: type, forPrimaryKey: primaryKey) {
                    observer(.success(object.toModel()))
                } else {
                    observer(.completed)
                }
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func fetchAll<T: ConvertibleToModel, U>(type: T.Type) -> Observable<U> where T: Object, T.M == U {
        return Observable.create() { observer in
            do {
                let realm = try Realm()
                realm.objects(type)
                    .map { $0.toModel() }
                    .forEach(observer.onNext)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func store<T: ConvertibleToRealmObject>(model: T) -> Completable {
        return Completable.create() { observer in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(model.toRealmObject())
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteAll(type: Object.Type) -> Completable {
        return Completable.create() { observer in
            do {
                let realm = try Realm()
                let objects = realm.objects(type)
                try realm.write {
                    realm.delete(objects)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteByPrimaryKey<T: ConvertibleToModel>(type: T.Type, primaryKey: String) -> Completable where T: Object {
        return Completable.create() { observer in
            do {
                let realm = try Realm()
                if let object = realm.object(ofType: type, forPrimaryKey: primaryKey) {
                    try realm.write {
                        realm.delete(object)
                    }
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}
