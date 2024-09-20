class InputArgument {
    [String] $name
    [String] $description
    [String[]] $value
    [String] ToString() {
        return $this.name
    }
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
    [InputArgument[]] $input_argument
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