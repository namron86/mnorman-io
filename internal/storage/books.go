package storage

import 	"github.com/aws/aws-sdk-go-v2/service/s3"

type BooksStorage struct {
	client *s3.Client
	bucket string
}

type Book struct { 
	Title string
	Author string
	ImageURL string
}

func NewBooksStorage(client *s3.Client, bucket string) *BooksStorage {
	return &BooksStorage{client: client, bucket: bucket}
}	

func (s *BooksStorage) ListBooks() ([]*Book, error) {
	return nil, nil
}

func (s *BooksStorage) GetBook(title string) (*Book, error) { 
	return nil, nil
}
