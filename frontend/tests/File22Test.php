<?php
use PHPUnit\Framework\TestCase;
use Demo\File22;

class File22Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File22::add(2, 3));
    }
}
