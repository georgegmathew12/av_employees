select * from (
    values
        (0, 'Greatest Generation', 1900, 1927, 0),
        (1, 'Silent Generation',   1928, 1945, 1),
        (2, 'Baby Boomer',         1946, 1964, 2),
        (3, 'Generation X',        1965, 1980, 3),
        (4, 'Millennial',          1981, 1996, 4),
        (5, 'Generation Z',        1997, 2012, 5),
        (6, 'Generation Alpha',    2013, 9999, 6)
) as g (generation_id, generation_name, min_year, max_year, sort_order)
