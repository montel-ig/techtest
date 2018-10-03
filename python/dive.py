class Octopus(Exception):

    def __init__(self, *args, **kwargs):
        self.color = kwargs['color'] if 'color' in kwargs else 'white'

    def get_color(self):
        return f"Color is {self.color}"


if __name__ ==  '__main__':

    o = Octopus()
    o2 = Octopus(color='blue')

    print(o.get_color())
    print(o2.get_color())
