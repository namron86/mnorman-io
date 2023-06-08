package storage

import 	"github.com/aws/aws-sdk-go-v2/service/s3"

type BooksStorage struct {
	client *s3.Client
}

type Book struct { 
	Title string
	Author string

}

func NewBooksStorage(client *s3.Client) *BooksStorage {
	return &BooksStorage{client: client}
}	

func (s *BooksStorage) ListBooks() ([]*Book, error) {
	return nil, nil
}	