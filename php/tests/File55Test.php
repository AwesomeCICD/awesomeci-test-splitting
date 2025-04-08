<?php
use PHPUnit\Framework\TestCase;
use Demo\File55;

class File55Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File55::add(2, 3));
    }
}
