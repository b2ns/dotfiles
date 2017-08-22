# Simple database using common-lisp
## Usage:
1.to get and set the fields:

    (get-fields)
    (set-fields :name :age :sex)

2.to show all item:

    (show-db)

3.to insert item:

    (insert-db "b2ns" "100" "male")
    (insert-db b2ns 100 male)

4.to select item:

    (select-db (where :name "b2ns"))
    (select-db (where :age 100 :sex male))

5.to update item:

    (update-db (where :name "b2ns") :age 1000)
    (update-db (where :age 100 :sex male) :name "Dovahkiin" :age 10)

6.to delete item:

    (delete-db (where :name "b2ns"))
    (delete-db (where :age 100 :sex male))

7.to clear the whole database:

    (clear-db)

8.to save the whole database:

    (save-db "file-name.db")

9.to load a database:

    (load-db "file-name.db")

