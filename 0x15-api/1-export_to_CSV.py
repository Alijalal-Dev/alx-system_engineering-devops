#!/usr/bin/python3
"""Export todo-list information of given employee in CSV."""
from requests import get
from sys import argv
from csv import writer, QUOTE_ALL


if __name__ == "__main__":
    id = argv[1]
    url = "https://jsonplaceholder.typicode.com/"
    user = get(url + "users/{}".format(id)).json()
    username = user.get("username")
    todos = get(url + "todos", params={"userId": id}).json()

    with open("{}.csv".format(id), "w", newline="") as fd:
        writer = writer(fd, quoting=QUOTE_ALL)
        [
            writer.writerow(
                [id, username, todo.get("completed"), todo.get("title")]
            )
            for todo in todos
        ]
