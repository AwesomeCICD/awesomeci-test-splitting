<?php
use PHPUnit\Framework\TestCase;
use Demo\File50;

class File50Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File50::add(2, 3));
    }
}
