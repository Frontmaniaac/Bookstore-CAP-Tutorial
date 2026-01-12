using {
    cuid,
    managed,
    sap.common.Currencies
} from '@sap/cds/common';
using {Attachments} from '@cap-js/attachments';

namespace tutorial.db;

entity Books : cuid, managed {
    title       : String;
    author      : Association to Authors;
    genre       : Association to Genres;
    publishedAt : Date;
    pages       : Integer;
    price       : Decimal(9, 2);
    currency    : Association to Currencies;
    stock       : Integer;
    status      : Association to BookStatus;
    Chapters    : Composition of many Chapters
                      on Chapters.book = $self;
}

entity Genres {
    key code        : Genre;
        description : String;
}

type Genre : String enum {
    Fiction = 'Fiction';
    Science = 'Science';
    Cooking = 'Cooking';
    Fantasy = 'Fantasy';
    Hobby = 'Hobby';
    Adventure = 'Adventure';
    SelfHelp = 'Self-Help';
    NonFiction = 'Non-Fiction';
    Art = 'Art';
    Children = 'Children';
}

entity BookStatus {
    key code        : String(1) enum {
            Available = 'A';
            Low_Stock = 'L';
            Unavailable = 'U';
        }
        criticality : Integer;
        displayText : String;
}

entity Authors : cuid, managed {
            name        : String;
            fileName    : String;
            fileType    : String      @Core.IsMediaType;
            content     : LargeBinary @Core.MediaType                  : fileType
                                      @Core.AcceptableMediaTypes       : ['application/pdf']
                                      @Core.ContentDisposition.Filename: fileName;
    virtual bookCount   : Integer;
            attachments : Composition of many Attachments;
            books       : Association to many Books
                              on books.author = $self;
}

entity Chapters : cuid, managed {
    key book   : Association to Books;
        number : Integer;
        title  : String;
        pages  : Integer;
}
