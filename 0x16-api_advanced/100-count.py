#!/usr/bin/python3
"""Module to count occurrences of words in titles of posts from a subreddit."""

from requests import get


def count_words(subreddit, word_list, instances={}, after="", count=0):
    """
    Count occurrences of words in titles of posts from a subreddit.

    Args:
        subreddit (str): The name of the subreddit.
        word_list (list): A list of words to count occurrences
                of in post titles.
        instances (dict, optional): A dictionary to store word occurrences.
        after (str, optional): Parameter to paginate through posts.
        count (int, optional): Total number of posts processed.
    """
    url = "https://www.reddit.com/r/{}/hot/.json".format(subreddit)
    header = {"user-agent": "Mozilla CPU iPhone OS 16_6 like Mac OS X"}
    param = {"limit": 100, "after": after, "count": count}
    response = get(url, headers=header, params=param, allow_redirects=False)
    try:
        results = response.json()
        if response.status_code != 200:
            raise Exception
    except Exception:
        return
    posts = results.get("data")
    after = posts.get("after")
    count += posts.get("dist")
    for post in posts.get("children"):
        title = post.get("data").get("title").lower().split()
        for word in word_list:
            if word.lower() in title:
                times = len([t for t in title if t == word.lower()])
                if instances.get(word.lower()) is None:
                    instances[word.lower()] = times
                else:
                    instances[word.lower()] += times
    if after is None:
        if len(instances) == 0:
            return
        instances = sorted(instances.items(), key=lambda kv: (-kv[1], kv[0]))
        [print("{}: {}".format(k, v)) for k, v in instances]
    else:
        return count_words(subreddit, word_list, instances, after, count)
