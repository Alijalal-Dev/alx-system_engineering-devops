#!/usr/bin/python3
"""Display todo-list information of given employee."""
from requests import get
from sys import argv


if __name__ == "__main__":
    id = argv[1]
    url = "https://jsonplaceholder.typicode.com/"
    user = get(url + "users/{}".format(id)).json()
    todos = get(url + "todos", params={"userId": id}).json()

    finished = [
        todo.get("title") for todo in todos if todo.get("completed") is True
    ]

    print(
        "Employee {} is done with tasks({}/{}):".format(
            user.get("name"), len(finished), len(todos)
        )
    )
    [print("\t {}".format(todo)) for todo in finished]
