using {tutorial.db as db} from '../db/schema';

service BookstoreService {
    entity Books   as projection on db.Books;
    entity Authors as projection on db.Authors;
    entity Chapters as projection on db.Chapters;
}