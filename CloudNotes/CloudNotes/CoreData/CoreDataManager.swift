//
//  CoreDataManager.swift
//  CloudNotes
//
//  Created by kjs on 2021/09/15.
//

import Foundation
import CoreData

final class CoreDataManager {
    private let persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CloudNotes")

        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                // TODO: - Remove below code, Show a message with alert controller, and Record this error
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()
    private lazy var context = persistentContainer.newBackgroundContext()
    private var storedCloudNoteList: [CloudNote]?

    func retrieveMemoList(
        completionHandler closure: @escaping (Result<[Memo], ErrorCases>) -> Void
    ) {
        context.perform {
            let cloudNoteRequest = NSFetchRequest<CloudNote>(entityName: Memo.associatedEntity)
            let keyForSotringByTime = NSSortDescriptor(
                key: Memo.CoreDataKey.lastUpdatedTime.rawValue,
                ascending: false
            )

            cloudNoteRequest.sortDescriptors = [keyForSotringByTime]

            do {
                let entity = try self.context.fetch(cloudNoteRequest)

                self.storedCloudNoteList = entity

                let placeholder = ""
                let memoList = entity.map { cloudNote in
                    return Memo(
                        title: cloudNote.title ?? placeholder,
                        body: cloudNote.body ?? placeholder,
                        lastUpdatedTime: cloudNote.lastUpdatedTime
                    )
                }

                DispatchQueue.main.async {
                    closure(.success(memoList))
                }
            } catch {
                DispatchQueue.main.async {
                    closure(.failure(.disabledInFetching))
                }
            }
        }
    }

    func updateMemo(
        with memo: Memo,
        at indexPath: IndexPath,
        completionHandler closure: @escaping (Result<Void, ErrorCases>) -> Void
    ) {
        guard let targetToUpdate = storedCloudNoteList?[indexPath.row] else {
            closure(.failure(.disabledInSearchingData))
            return
        }

        context.perform {
            targetToUpdate.title = memo.title
            targetToUpdate.body = memo.body
            targetToUpdate.lastUpdatedTime = memo.lastUpdatedTime

            do {
                try self.context.save()

                DispatchQueue.main.async {
                    closure(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    closure(.failure(.disabledInSavingContext))
                }
            }
        }
    }

    func createMemo(
        with memo: Memo,
        completionHandler closure: @escaping (Result<Void, ErrorCases>) -> Void
    ) {
        context.perform {
            let context = self.context
            let entity = NSEntityDescription.insertNewObject(forEntityName: Memo.associatedEntity, into: context)

            entity.setValue(memo.title, forKey: Memo.CoreDataKey.title.rawValue)
            entity.setValue(memo.body, forKey: Memo.CoreDataKey.body.rawValue)
            entity.setValue(memo.lastUpdatedTime, forKey: Memo.CoreDataKey.lastUpdatedTime.rawValue)

            context.refresh(entity, mergeChanges: true)

            let insertedCloudNote = context.insertedObjects.first as? CloudNote

            do {
                try context.save()

                if let newCloudNote = insertedCloudNote {
                    self.storedCloudNoteList?.insert(newCloudNote, at: .zero)
                }

                DispatchQueue.main.async {
                    closure(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    closure(.failure(.disabledInSavingContext))
                }
            }
        }
    }

    func deleteMemo(
        at indexPath: IndexPath,
        completionHandler closure: @escaping (Result<Void, ErrorCases>) -> Void
    ) {
        guard let targetToDelete = storedCloudNoteList?[indexPath.row] else {
            closure(.failure(.disabledInSearchingData))
            return
        }

        context.perform {
            do {
                self.context.delete(targetToDelete)
                try self.context.save()
                self.storedCloudNoteList?.remove(at: indexPath.row)

                DispatchQueue.main.async {
                    closure(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    closure(.failure(.disabledInSavingContext))
                }
            }
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    enum ErrorCases: LocalizedError {
        case disabledInFetching
        case disabledInSearchingData
        case disabledInSavingContext

        var errorDescription: String? {
            switch self {
            case .disabledInFetching:
                return "Error: Failed to fetch, I don't know what to do..."
            case .disabledInSearchingData:
                return "Error: Failed to search your data, please report this..."
            case .disabledInSavingContext:
                return "Error: Failed to save context. Check your environment"
            }
        }
    }
}
