inp = input()
v = []

for i in range(inp):
	a, b = raw_input().split()
	a, b = int(a), float(b)
	c = a/(b**2)
	if c < 18.5:
		r = "under"
	elif c >= 18.5 and c < 25.0:
		r = "normal"
	elif c>=25.0 and c < 30.0:
		r = "over"
	else:
		r = "obese"
	v. append(r)

print ' '.join(x for x in v)