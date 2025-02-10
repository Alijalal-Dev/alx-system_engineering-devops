#!/usr/bin/python3
"""Export todo-list information of given employee in JSON."""
from requests import get
from sys import argv
from json import dump


if __name__ == "__main__":
    id = argv[1]
    url = "https://jsonplaceholder.typicode.com/"
    user = get(url + "users/{}".format(id)).json()
    username = user.get("username")
    todos = get(url + "todos", params={"userId": id}).json()

    with open("{}.json".format(id), "w") as fd:
        dump(
            {
                id: [
                    {
                        "task": todo.get("title"),
                        "completed": todo.get("completed"),
                        "username": username,
                    }
                    for todo in todos
                ]
            },
            fd,
        )
