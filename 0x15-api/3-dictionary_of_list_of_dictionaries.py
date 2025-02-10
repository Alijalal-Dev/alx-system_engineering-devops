#!/usr/bin/python3
"""Export todo-list information of all employees in JSON."""
from requests import get
from json import dump


if __name__ == "__main__":
    url = "https://jsonplaceholder.typicode.com/"
    users = get(url + "users").json()

    with open("todo_all_employees.json", "w") as fd:
        dump(
            {
                user.get("id"): [
                    {
                        "task": todo.get("title"),
                        "completed": todo.get("completed"),
                        "username": user.get("username"),
                    }
                    for todo in get(
                        url + "todos", params={"userId": user.get("id")}
                    ).json()
                ]
                for user in users
            },
            fd,
        )
