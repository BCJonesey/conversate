lastId = 1
TemporaryIdFactory = {
  nextId: () -> "Temporary_ID_#{lastId++}"
}

Structural.Data.TemporaryIdFactory = TemporaryIdFactory
