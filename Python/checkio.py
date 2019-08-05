def checkio(list):
    if len(list)<5:
        a = 0
        try:
            a = list[0]
            try:
                a = a + list[1]
                try:
                    a = a +list[2]
                    try:
                        a = a + list[3]
                    except Exception:
                        pass
                except Exception:
                    pass
            except Exception:
                pass
        except Exception:
            pass
        return a
    else:
        return checkio(list[:int(len(list)/2)]) + checkio(list[int(len(list)/2):])
