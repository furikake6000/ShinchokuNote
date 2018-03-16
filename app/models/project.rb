class Project < Note
  enum stage: {
    idea: 0,
    standby: 1,
    in_progress: 2,
    finished: 3,
    frozen: 4,
    closed: 5
  }, _suffix: true
end
