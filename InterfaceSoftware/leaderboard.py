import json

DEFAULT_LEADERBOARD_PATH = 'leaderboard.json'

def fetch_leaderboard(path=DEFAULT_LEADERBOARD_PATH):
    '''
    Reads ordered leaderboard from specified json
    Returns empty list if no entries are available
    '''
    try:
        with open(path, 'r') as f:
            return sort_leaderboard(json.load(f))
    except (json.JSONDecodeError, FileNotFoundError) as e:
        return []

def sort_leaderboard(leaderboard):
    '''
    Sorts leaderboard by score
    '''
    return sorted(leaderboard, key=lambda x:x['score'], reverse=True)

def append_leaderboard(name, score, path=DEFAULT_LEADERBOARD_PATH):
    '''
    Adds entry to leaderboard based on name and score
    '''
    leaderboard = fetch_leaderboard(path)
    leaderboard.append(dict(name=name, score=score))
    leaderboard = sort_leaderboard(leaderboard)
    with open(path, 'w+') as f:
        json.dump(leaderboard, f)
    return leaderboard

def print_leaderboard(leaderboard):
    for entry in leaderboard:
        # f-string para formatar float com 2 pontos decimais
        print(f"{entry['name']} - {entry['score']:.2f}")

def example():
    print("Leaderboard at start:")
    print_leaderboard(fetch_leaderboard())
    append_leaderboard("fulaaano", 123.459)
    append_leaderboard("cicldano", 194.5)
    print("Leaderboard at end:")
    print_leaderboard(fetch_leaderboard())

if __name__ == "__main__":
    example()