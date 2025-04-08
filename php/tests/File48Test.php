<?php
use PHPUnit\Framework\TestCase;
use Demo\File48;

class File48Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File48::add(2, 3));
    }
}
