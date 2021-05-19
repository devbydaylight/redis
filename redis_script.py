import redis

redis = redis.Redis(host= '172.31.28.194', port= '6379')
redis.set('a', 5)
redis.set('b', 6)
redis.call('set','c',redis.call('get','a')+redis.call('get','b')) # can't quite get this to work correctly, no attribute for redis.call. Need to research later.
value1 = redis.get('a')
value2 = redis.get('b')
value3 = redis.get('c')
print(value1)
print(value2)
print(value3)
