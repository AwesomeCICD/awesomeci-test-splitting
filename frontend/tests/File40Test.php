<?php
use PHPUnit\Framework\TestCase;
use Demo\File40;

class File40Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File40::add(2, 3));
    }
}
