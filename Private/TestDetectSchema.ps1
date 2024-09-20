class InputArgument {
    [String] $name
    [String] $description
    [String[]] $value
    [String] ToString() {
        return $this.name
    }
}

class TestExecutor {
    [String] $name
    [String] $command
    [String] $cleanup_command
    [String] ToString() {
        return $this.name
    }
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
    [String] $description
    [String] $cleanup_order
    [TestObject[]] $tests
    [String] ToString() {
        return $this.name
    }
}