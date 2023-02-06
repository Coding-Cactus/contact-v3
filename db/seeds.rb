%w[warn ban].each { |type| Type.create(name: type)  }
%w[incomplete in-progress accepted denied].each { |status| Status.create(name: status)  }
