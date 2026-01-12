const { Books, Authors } = require('#cds-models/BookstoreService')
const { Genre } = require('#cds-models/tutorial/db')
const cds = require('@sap/cds')

module.exports = class BookstoreService extends cds.ApplicationService {
  init() {

    this.on('addDiscount', async () => {
      await UPDATE(Books).set({
        price: {
          func: 'ROUND',
          args: [{
            xpr: [{ ref: ['price'] }, '*',
            { val: 0.9 }]
          },
          { val: 2 }]
        }
      })
    })

    this.on('addStock', Books, async (req) => {
      const bookId = req.params[0].ID
      await UPDATE(Books)
        .set({ stock: { '+=': 1 } })
        .where({ ID: bookId })
    })

    this.on('changePublishDate', Books, async (req) => {
      const bookId = req.params[0].ID
      const newDate = req.data.newDate
      await UPDATE(Books)
        .set({ publishedAt: newDate })
        .where({ ID: bookId })
    })

    this.on('changeStatus', Books, async (req) => {
      const bookId = req.params[0].ID
      const newStatus = req.data.newStatus
      await UPDATE(Books)
        .set({ status_code: newStatus })
        .where({ ID: bookId })
    })

    this.before('READ', Books, async (req) => {
    })
    this.on('READ', Books, async (req, next) => {
      return next()
    })
    this.after('READ', Books, async (books, req) => {
      for (const book of books) {
        if (book.genre_code === Genre.Art) {
          book.price = book.price * 0.8
        }
      }
    })

    this.after('READ', Authors, async (authors) => {
      const ids = authors.map(author => author.ID)
      const bookCounts = await SELECT.from(Books)
        .columns('author_ID', { func: 'count' })
        .where({ author_ID: { in: ids } })
        .groupBy('author_ID');
      for(const author of authors){
        const bookCount = bookCounts.find(bookCount => bookCount.author_ID = author.ID)
        author.bookCount = bookCount.count
      }

    })

    return super.init()
  }
}
