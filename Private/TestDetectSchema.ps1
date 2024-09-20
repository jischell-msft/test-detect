class InputArgumentBase {
    [String] $name
    [String] $description
    [String] ToString() {
        return $this.name
    }
}

class InputArgumentMulti : InputArgumentBase {
    [String[]] $value
}

class InputArgumentPowershell : InputArgumentBase {
    [String] $value
}

class InputArgumentStatic : InputArgumentBase {
    [String] $value
}

class TestExecutorBase {
    [String] $name
    [String] ToString() {
        return $this.name
    }
}

class TestExecutor: TestExecutorBase {
    [String] $command
    [String] $cleanup_command
}

class TestObject {
    [String] $name
    [String] $guid
    [String] $description
    [int] $process_order
    [Hashtable] $input_argument
    [TestExecutor] $executor
    [String] ToString() {
        return $this.name
    }
}

class CampaignObject {
    [String] $name
    [TestObject[]] $tests
    [String] $cleanup_order
    [String] ToString() {
        return $this.name
    }
}