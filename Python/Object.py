from abc import ABC, abstractmethod

class Object(ABC):
    @abstractmethod
    def __str__(self):
        pass
